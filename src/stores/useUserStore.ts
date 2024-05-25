import { create } from "zustand";
import CashFlowLocalStorage from "@/services/asyncStorage";


interface IUserStore {
    user: Object | null;
    token: string | null;
    updateToken: (token: string | null) => void;
    updateUser: (user: Object | null) => void;
    updateOnBoarding: (onBoarding: boolean) => void;
    logout: () => void;
    onBoarding: boolean;
}
const useUserStore = create<IUserStore>()(
        (set, get) => ({
            user: null,
            token : null,
            onBoarding:false,
            updateUser: (user) => {
                CashFlowLocalStorage.storeData("user", JSON.stringify(user));
                set({ user });
            },
            updateToken: async (token) => {
               if(token){
                   await CashFlowLocalStorage.storeData("token", token);
                   set({ token });
               }
               set({ token });
            },
            logout: () => {
                CashFlowLocalStorage.clearAll();
                set({ user: null, token: null });
            },
            updateOnBoarding: (onBoarding) => {
                CashFlowLocalStorage.storeData("onboarding", onBoarding.toString());
                set({ onBoarding });
            }
        }),
);

export default useUserStore;