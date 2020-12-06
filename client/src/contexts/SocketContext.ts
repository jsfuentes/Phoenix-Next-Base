import React from "react";

const SocketContext = React.createContext({
  socket: null,
  myChannel: null,
});

export default SocketContext;
