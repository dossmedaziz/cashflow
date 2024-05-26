import { create } from "zustand";
import CashFlowLocalStorage from "@/services/asyncStorage";
import { UserStore} from "@/types";



const useUserStore = create<UserStore>()(
        (set, get) => ({
            user: null,
            token : null,
            onBoarding:false,
            updateUser:  (user) => {
                 CashFlowLocalStorage.storeData("user", JSON.stringify(user));
                    set({ user });
            },
            updateToken:  (token) => {
                    CashFlowLocalStorage.storeData("token", JSON.stringify(token));
                   set({ token });
            },
            logout: () => {
                CashFlowLocalStorage.clearAll();
                set({ user: null, token: null });
            },
            updateOnBoarding: async (onBoarding) => {
                await CashFlowLocalStorage.storeData("onboarding", onBoarding.toString());
                set({ onBoarding });
            }
        }),
);

export default useUserStore;