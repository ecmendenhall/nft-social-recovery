import { ReactElement } from "react";
import { Container, Button } from "@mui/material";
import { Lock } from "@mui/icons-material";
import { InjectedConnector } from "@web3-react/injected-connector";
import { useWeb3React } from "@web3-react/core";

const injected = new InjectedConnector({
  supportedChainIds: [1],
});

const App: React.FC = (): ReactElement => {
  // eslint-disable-next-line prettier/prettier
  const { active, account, activate, deactivate } = useWeb3React();
  const connect = async () => {
    try {
      await activate(injected);
    } catch (err) {
      console.log(err);
    }
  };

  const disconnect = async () => {
    try {
      deactivate();
    } catch (err) {
      console.log(err);
    }
  };

  return (
    <div className="App">
      <header>
        <Container
          sx={{
            display: "flex",
            color: "white",
            fontSize: 35,
            marginBottom: 10,
            padding: 2,
            gap: 1,
            bgcolor: "#282c34",
            justifyContent: "center",
            alignItem: "center",
          }}
        >
          <div>NFT Social Recovery</div>
          <Lock />
        </Container>
      </header>
      <Container
        sx={{
          display: "flex",
          justifyContent: "center",
          alignItem: "center",
        }}
      >
        {active ? (
          <span>
            Connected with <b>{account}</b>
          </span>
        ) : (
          <Button variant="contained" onClick={connect}>
            Connect Wallet
          </Button>
        )}
        <Button variant="contained" onClick={disconnect}>
          Disconnect
        </Button>
      </Container>
    </div>
  );
};

export default App;
