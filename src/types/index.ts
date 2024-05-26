export type SignInForm = {
    email: string;
    password: string;
};

export  type SignUpForm = {
    email: string;
    password: string;
    firstName: string;
    lastName: string;
};

export type UserDeviceDetails={
    onBoarding:boolean;
}

export type LoginResponse={
    token:AccessToken;
    user:User;
}


export type User={
    id:string;
    email:string;
    firstName:string;
    lastName:string;
}
export type AccessToken={
    token:string;
    expiresAt:string;
    type:string;
}