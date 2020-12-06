import { useEffect } from 'react';
import Head from 'next/head'

import styles from 'styles/Home.module.css'
import {axios} from "src/utils/utils"
import Question from "src/components/Question"

export default function Home() {
  useEffect(() => {
    async function f() {
      try {
        const resp = await axios.get("/api");
        console.log("REsP", resp)

      } catch(err) {
        console.log("ERRR", err)
      }
    }

    f();
  }, [])

  return (
    <div className={styles.container}>
      <Head>
        <title>Create Next App</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <Question/>
    </div>
  )
}
