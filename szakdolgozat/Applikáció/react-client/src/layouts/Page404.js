import React from "react";
import styled from "styled-components/macro";
import { Link } from "react-router-dom";

import Helmet from "react-helmet";

import { Button as MuiButton, Typography } from "@material-ui/core";
import { spacing } from "@material-ui/system";

const Button = styled(MuiButton)(spacing);

const Wrapper = styled.div`
  padding: ${(props) => props.theme.spacing(6)}px;
  text-align: center;
  background: transparent;

  ${(props) => props.theme.breakpoints.up("lg")} {
    padding: ${(props) => props.theme.spacing(10)}px;
  }
`;

function Page404() {
  return (
    <Wrapper>
      <Helmet title="404 Error" />
      <Typography component="h1" variant="h1" align="center" gutterBottom>
        404
      </Typography>
      <Typography component="h2" variant="h5" align="center" gutterBottom>
        Az oldal nem található.
      </Typography>
      <Typography component="h2" variant="body1" align="center" gutterBottom>
        Lehetséges, hogy a keresett oldalt eltávolították.
      </Typography>

      <Button
        component={Link}
        to="/"
        variant="contained"
        color="secondary"
        mt={2}
      >
        Vissza a főoldalra
      </Button>
    </Wrapper>
  );
}

export default Page404;
