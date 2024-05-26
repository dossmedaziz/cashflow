import { create } from "zustand";
import CashFlowLocalStorage from "@/services/asyncStorage";
import {AccessToken, User} from "@/types";


interface IUserStore {
    user: User | null;
    token: AccessToken | null;
    updateToken: (token: AccessToken | null) => void;
    updateUser: (user: User | null) => void;
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
                   await CashFlowLocalStorage.storeData("token", JSON.stringify(token));
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