import CashFlowLocalStorage from "@/services/asyncStorage";
import AuthService from "@/services/authService";
import { TransactionStore, UserStore} from "@/types";


 const init =  async (userStore : UserStore , transactionStore : TransactionStore) => {
     await  loadConnectedUser(userStore)
}

const loadConnectedUser = async (userStore : UserStore) => {
    const {updateUser, updateOnBoarding,updateToken} = userStore;
     let accessToken =await CashFlowLocalStorage.getData("token")
    if(accessToken){
        AuthService.connectedUser()
            .then((response) => {
                const {user} = response.data;
                updateUser(user)
            })
            .catch((error) => {
                console.log(error)
            })
    }
     const onboarding=await CashFlowLocalStorage.getData("onboarding")
     await updateOnBoarding(onboarding === "true")
}
export default {
    init
}