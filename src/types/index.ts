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