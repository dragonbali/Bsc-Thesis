import React from "react";

import EnhancedTable from "./EnhancedTable";

import styled from "styled-components/macro";

import Helmet from "react-helmet";

import { Divider as MuiDivider, Grid, Typography } from "@material-ui/core";

import { spacing } from "@material-ui/system";

const Divider = styled(MuiDivider)(spacing);

function OrderList() {
  return (
    <React.Fragment>
      <Helmet title="Megrendelések" />

      <Grid justify="space-between" container spacing={24}>
        <Grid item>
          <Typography variant="h3" gutterBottom display="inline">
            Megrendelések
          </Typography>
        </Grid>
      </Grid>
      <Divider my={6} />
      <Grid container spacing={6}>
        <Grid item md={12}>
          <EnhancedTable />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

export default OrderList;
