"use client";

import "@rainbow-me/rainbowkit/styles.css";
import { RainbowKitProvider, getDefaultConfig } from "@rainbow-me/rainbowkit";
import { WagmiProvider, http, cookieToInitialState } from "wagmi";
import { baseSepolia } from "wagmi/chains";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";

const config = getDefaultConfig({
    appName: "EARN Launchpad",
    projectId: "YOUR_WALLETCONNECT_PROJECT_ID",
    chains: [baseSepolia],
    transports: {
        [baseSepolia.id]: http(),
    },
});

const queryClient = new QueryClient();

export default function Providers({ children, cookie }: { children: React.ReactNode, cookie: string | null }) {
    const initialState = cookieToInitialState(config, cookie);
    return (
        <WagmiProvider config={config}>
            <QueryClientProvider client={queryClient}>
                <RainbowKitProvider>{children}</RainbowKitProvider>
            </QueryClientProvider>
        </WagmiProvider>
    );
}
