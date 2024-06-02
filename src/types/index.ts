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

export type  UserStore ={
    user: User | null;
    token: AccessToken | null;
    updateToken: (token: AccessToken | null) => void;
    updateUser: (user: User | null) => void;
    updateOnBoarding: (onBoarding: boolean) => void;
    logout: () => void;
    onBoarding: boolean;
}


export type TransactionStore={
    transactions: Transaction[];
    transactionCategories: TransactionCategory[];
    transactionTypes: TransactionType[];
    addTransaction: (transaction: Transaction) => void;
    addTransactions: (transactions: Transaction[]) => void;
    addTransactionCategories: (transactionCategories: TransactionCategory[]) => void;
    addTransactionTypes: (transactionTypes: TransactionType[]) => void;

}

export type Transaction={
    id:string;
    amount:number;
    transactionDate:string;
    description:string;
    transactionCategory:TransactionCategory;
}
export type TransactionCategory={
    id:string;
    name:string;
    transactionType:TransactionType;
}

export type TransactionType={
    id:string;
    name:string;
}

export type TransactionForm={
    amount:number;
    transactionDate:string;
    description:string;
    transactionCategoryId:string;
}