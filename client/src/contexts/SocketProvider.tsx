import React, { useState, useEffect } from "react";
import { Socket } from "phoenix";
import { nanoid } from "nanoid";
import PropTypes from "prop-types";

import conf from "conf";
import SocketContext from "./SocketContext";
const debug = require("debug")("app:SocketProvider");

SocketProvider.propTypes = {
  children: PropTypes.node.isRequired,
};

export default function SocketProvider(props) {
  const [uid, setUid] = useState(null);
  const [socket, setSocket] = useState(null);
  const [myChannel, setMyChannel] = useState(null);

  useEffect(() => {
    const newUid = nanoid(6);
    setUid(newUid);
    debug("USING SOCKET", conf.get("SOCKET_URL"));
    const newSocket = new Socket(conf.get("SOCKET_URL"), {
      params: { user_id: newUid },
    });
    setSocket(newSocket);
    newSocket.connect();
    debug("Connected to Socket");

    const newMyChannel = newSocket.channel(`user:${newUid}`, {});
    newMyChannel.join().receive("ok", () => {
      debug("Joined MyChannel");
      setMyChannel(newMyChannel);
    });

    return () => {
      newSocket.disconnect(() => debug("Disconnect from old socket"));
      newMyChannel.leave().receive("ok", () => debug("Left MyChannel"));
    };
  }, []);

  return (
    <SocketContext.Provider
      value={{
        socket,
        myChannel,
      }}
    >
      {props.children}
    </SocketContext.Provider>
  );
}
