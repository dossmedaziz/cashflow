export type SignInForm = {
    email: string;
    password: string;
};

export type SignUpForm = {
    email: string;
    password: string;
    password_confirmation: string;
};

export type UserDeviceDetails={
    onBoarding:boolean;
}