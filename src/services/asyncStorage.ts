import AsyncStorage from '@react-native-async-storage/async-storage';



export const storeData = async (key: string, value: string) => {
    try {
        await AsyncStorage.setItem(key, value);
    } catch (error) {
        console.log(error);
    }
};

export const getData = async (key: string) => {
    try {
        const value = await AsyncStorage.getItem(key);
        if (value !== null) {
            return value;
        }
    } catch (error) {
        console.log(error);
    }
};

export const removeData = async (key: string) => {
    try {
        await AsyncStorage.removeItem(key);
    } catch (error) {
        console.log(error);
    }
};

export const clearAll = async () => {
    try {
        await AsyncStorage.clear();
    } catch (error) {
        console.log(error);
    }
};