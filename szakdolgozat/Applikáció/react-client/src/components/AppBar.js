import React from "react";
import styled, { withTheme } from "styled-components/macro";

import { Hidden, IconButton as MuiIconButton } from "@material-ui/core";

import { Menu as MenuIcon } from "@material-ui/icons";

const IconButton = styled(MuiIconButton)`
  svg {
    width: 22px;
    height: 22px;
  }
`;

const AppBarComponent = ({ onDrawerToggle }) => (
  <React.Fragment>
    <Hidden mdUp>
      <IconButton
        color="inherit"
        aria-label="Open drawer"
        onClick={onDrawerToggle}
      >
        <MenuIcon />
      </IconButton>
    </Hidden>
  </React.Fragment>
);

export default withTheme(AppBarComponent);
