import CashFlowLocalStorage from "@/services/asyncStorage";
import AuthService from "@/services/authService";


 const init = async ({updateToken ,updateUser , updateOnBoarding } : any) => {
    await CashFlowLocalStorage.getData("token")
        .then((token) => {
        if (!token) return;
        token = JSON.parse(token)
        updateToken(token)
        AuthService.connectedUser(token.token)
            .then((response) => {
                let {user} = response.data;
                updateUser(user)
            })
            .catch((error) => {
                console.log(error)
            })
    })

    await CashFlowLocalStorage.getData("onboarding")
        .then((onboarding) => {
            updateOnBoarding(onboarding === "true")
        })
}

export default {
    init
}