import { Text } from "react-native";
import { Link } from "expo-router";

export default function Page() {
    return (
        <>
            <Text>Hello World!</Text>
            <Link href="/settings">Settings</Link>
            <Link href="/oauth">Oauth</Link>
        </>
    );
}
