import React from "react";
import styled, { withTheme } from "styled-components/macro";

import { Helmet } from "react-helmet";

import {
  Grid,
  Divider as MuiDivider,
  Typography as MuiTypography,
} from "@material-ui/core";

import { green, red } from "@material-ui/core/colors";

import { spacing } from "@material-ui/system";

import Actions from "./Actions";
import BarChart from "./BarChart";
import BarChartSales from "./BarChartSales";
import DoughnutChart from "./DoughnutChart";
import LanguagesTable from "./LanguagesTable";
import Stats from "./Stats";
import TrafficTable from "./TrafficTable";
import WorldMap from "./WorldMap";
import LineChart from "./LineChart";
import RadarChart from "./RadarChart";
import PieChart from "./PieChart";

const Divider = styled(MuiDivider)(spacing);

const Typography = styled(MuiTypography)(spacing);

function Analytics({ theme }) {
  return (
    <React.Fragment>
      <Helmet title="Analytics Dashboard" />
      <Grid justify="space-between" container spacing={6}>
        <Grid item>
          <Typography variant="h3" gutterBottom>
            Analitikai felület
          </Typography>
        </Grid>

        <Grid item>
          <Actions />
        </Grid>
      </Grid>

      <Divider my={6} />

     
      <Grid container spacing={6}>
        <Grid item xs={12} lg={4}>
          <DoughnutChart />  
        </Grid>
        <Grid item xs={12} lg={8}>
          <LineChart />
        </Grid>
      </Grid>

      <Grid container spacing={6}>
        <Grid item xs={12} lg={6}>
          <RadarChart />  
        </Grid>
        <Grid item xs={12} lg={6}>
          <BarChart />  
        </Grid>
      </Grid>

      <Grid container spacing={6}>
        <Grid item xs={12} lg={8}>
          <BarChartSales />
        </Grid>
        <Grid item xs={12} lg={4}>
         <PieChart />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

export default withTheme(Analytics);
