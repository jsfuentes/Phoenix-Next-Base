import React from 'react'
import { AppProps } from 'next/app'
import SocketProvider from "src/contexts/SocketProvider";

import 'styles/tailwind.css'

function MyApp({ Component, pageProps }: AppProps) {
  return (
    <SocketProvider>
      <Component {...pageProps} />
    </SocketProvider>
  )
}

export default MyApp


