import AsyncStorage from "@react-native-async-storage/async-storage";

// To save a setting
export async function saveSetting(key: string, value: string) {
    try {
        await AsyncStorage.setItem(key, JSON.stringify(value));
    } catch (error) {
        console.error("Error saving setting:", error);
    }
}

// To retrieve a setting
export async function getSetting(key: string) {
    try {
        const value = await AsyncStorage.getItem(key);
        if (value !== null) {
            return JSON.parse(value);
        }
    } catch (error) {
        console.error("Error getting setting:", error);
    }
}
