import { create } from "zustand";
import CashFlowLocalStorage from "@/services/asyncStorage";


interface IUserStore {
    user: Object | null;
    token: string | null;
    updateToken: (token: string | null) => void;
    updateUser: (user: Object | null) => void;
    logout: () => void;
}
const useUserStore = create<IUserStore>()(
        (set, get) => ({
            user: null,
            token : null,
            updateUser: (user) => {
                CashFlowLocalStorage.storeData("user", JSON.stringify(user));
                set({ user });
            },
            updateToken: async (token) => {
               await CashFlowLocalStorage.storeData("token", token);
                set({ token });
            },
            logout: () => {
                CashFlowLocalStorage.clearAll();
                set({ user: null, token: null });
            },
        }),
);

export default useUserStore;