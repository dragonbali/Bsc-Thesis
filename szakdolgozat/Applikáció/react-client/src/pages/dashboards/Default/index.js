import React, { useState, useEffect } from "react";
import axios from "axios";
import styled from "styled-components/macro";

import { Helmet } from "react-helmet";

import {
  Grid,
  Divider as MuiDivider,
  Typography as MuiTypography,
} from "@material-ui/core";

import { spacing } from "@material-ui/system";
import DoughnutChart from "./DoughnutChart";
import Stats from "./Stats";
import Stats2 from "./Stats2";
import Table from "./Table";
import { API_URL } from "../../../constants";

const Divider = styled(MuiDivider)(spacing);

const Typography = styled(MuiTypography)(spacing);

function Default() {
  //api
  const [error, setError] = useState(null);
  const [isLoaded, setIsLoaded] = useState(false);
  const [items, setData] = useState([]);
  const [workers, setWorkers] = useState([]);
  const [billing, setBilling] = useState([]);
  useEffect(() => {
    const fetchData = async () => {
      setIsLoaded(false);
      try {
        const [sales, workers, billing] = await axios.all([
          axios.get(API_URL + "/info/sales"),
          axios.get(API_URL + "/workers"),
          axios.get(API_URL + "/info/billings"),
        ]);
        setData(sales.data);
        setWorkers(workers.data);
        setBilling(billing.data);
      } catch (error) {
        setError(error);
      }
      setIsLoaded(true);
    };
    fetchData();
  }, []);
  if (error) {
    return <div>Error: {error.message}</div>;
  } else if (!isLoaded) {
    return <div>Loading...</div>;
  } else {
    const pendingOrders = () => {
      let counter = 0;
      for (let i = 0; i < billing.rows.length; i++) {
        const element = billing.rows[i];
        if (
          element.payment_method === "bank transfer" &&
          element.completed === false
        ) {
          counter++;
        }
      }
      return counter;
    };

    const showPercentageText = (number) => {
      if (number === null) {
        return "0%";
      }
      if (Math.sign(number) === 1) {
        return "+" + number.toFixed(0) + "%";
      }
      return number.toFixed(0) + "%";
    };

    const showPercentageColor = (number) => {
      if (Math.sign(number) === 1) {
        return "#4caf50";
      }
      return "#f44336";
    };
    return (
      <React.Fragment>
        <Helmet title="Default Dashboard" />
        <Grid justify="space-between" container spacing={6}>
          <Grid item>
            <Typography variant="h3" gutterBottom>
              Alap adatok
            </Typography>
          </Grid>
        </Grid>

        <Divider my={6} />

        <Grid container spacing={6}>
          <Grid item xs={12} sm={12} md={6} lg={3} xl>
            <Stats
              title="Eladások"
              amount={items.rows.day.quantity}
              chip="Ma"
              percentageText={showPercentageText(
                items.rows.day.quantityPercent
              )}
              percentagecolor={showPercentageColor(
                items.rows.day.quantityPercent
              )}
            />
          </Grid>
          <Grid item xs={12} sm={12} md={6} lg={3} xl>
            <Stats
              title="Eladások"
              amount={items.rows.week.quantity}
              chip="Heti"
              percentageText={showPercentageText(
                items.rows.week.quantityPercent
              )}
              percentagecolor={showPercentageColor(
                items.rows.week.quantityPercent
              )}
            />
          </Grid>
          <Grid item xs={12} sm={12} md={6} lg={3} xl>
            <Stats
              title="Eladások"
              amount={items.rows.month.quantity}
              chip="Havi"
              percentageText={showPercentageText(
                items.rows.month.quantityPercent
              )}
              percentagecolor={showPercentageColor(
                items.rows.month.quantityPercent
              )}
            />
          </Grid>
          <Grid item xs={12} sm={12} md={6} lg={3} xl>
            <Stats2
              title="Függőben lévő rendelés"
              amount={pendingOrders}
              chip="Most"
            />
          </Grid>
        </Grid>
        <Grid container spacing={6}>
          <Grid item xs={12} sm={12} md={6} lg={3} xl>
            <Stats
              title="Bevétel"
              amount={items.rows.day.money + " Ft"}
              chip="Ma"
              percentageText={showPercentageText(items.rows.day.moneyPercent)}
              percentagecolor={showPercentageColor(
                items.rows.month.moneyPercent
              )}
            />
          </Grid>
          <Grid item xs={12} sm={12} md={6} lg={3} xl>
            <Stats
              title="Bevétel"
              amount={items.rows.week.money + " Ft"}
              chip="Heti"
              percentageText={showPercentageText(items.rows.week.moneyPercent)}
              percentagecolor={showPercentageColor(
                items.rows.week.moneyPercent
              )}
            />
          </Grid>
          <Grid item xs={12} sm={12} md={6} lg={3} xl>
            <Stats
              title="Bevétel"
              amount={items.rows.month.money + " Ft"}
              chip="Havi"
              percentageText={showPercentageText(items.rows.month.moneyPercent)}
              percentagecolor={showPercentageColor(
                items.rows.month.moneyPercent
              )}
            />
          </Grid>
          <Grid item xs={12} sm={12} md={6} lg={3} xl>
            <Stats2
              title="Összes regisztrált szaki"
              amount={workers.rows.length}
              chip="Most"
            />
          </Grid>
        </Grid>
        <Grid container spacing={6}>
          <Grid item xs={12} lg={8}>
            <Table />
          </Grid>
          <Grid item xs={12} lg={4}>
            <DoughnutChart />
          </Grid>
        </Grid>
      </React.Fragment>
    );
  }
}

export default Default;
