import React, { useEffect, useState } from "react";
import axios from "axios";
import { API_URL } from "../../../constants";
import styled, { withTheme } from "styled-components/macro";

import { orange, green, red } from "@material-ui/core/colors";

import {
  Card as MuiCard,
  CardContent,
  CardHeader,
  IconButton,
  Table,
  TableBody,
  TableCell as MuiTableCell,
  TableHead,
  TableRow as MuiTableRow,
  Typography,
} from "@material-ui/core";

import { spacing } from "@material-ui/system";

import { Doughnut } from "react-chartjs-2";

import { MoreVertical } from "react-feather";

const Card = styled(MuiCard)(spacing);

const ChartWrapper = styled.div`
  height: 168px;
  position: relative;
`;

const DoughnutInner = styled.div`
  width: 100%;
  position: absolute;
  top: 50%;
  left: 0;
  margin-top: -22px;
  text-align: center;
  z-index: 0;
`;

const TableRow = styled(MuiTableRow)`
  height: 42px;
`;

const TableCell = styled(MuiTableCell)`
  padding-top: 0;
  padding-bottom: 0;
`;

const GreenText = styled.span`
  color: ${() => green[400]};
  font-weight: ${(props) => props.theme.typography.fontWeightMedium};
`;

const RedText = styled.span`
  color: ${() => red[400]};
  font-weight: ${(props) => props.theme.typography.fontWeightMedium};
`;

const DoughnutChart = ({ theme }) => {
  const [error, setError] = useState(null);
  const [isLoaded, setIsLoaded] = useState(false);
  const [salesinfo, setSalesinfo] = useState([]);
  useEffect(() => {
    const fetchData = async () => {
      setIsLoaded(false);
      try {
        const [sales] = await axios.all([axios.get(API_URL + "/info/sales")]);
        setSalesinfo(sales.data);
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
    const data = {
      labels: ["3 Havi", "6 Havi", "12 Havi"],
      datasets: [
        {
          data: [
            salesinfo.rows.month.package.threeMonth,
            salesinfo.rows.month.package.sixMonth,
            salesinfo.rows.month.package.twelveMonth,
          ],
          backgroundColor: [
            theme.palette.secondary.main,
            red[500],
            orange[500],
          ],
          borderWidth: 5,
          borderColor: theme.palette.background.paper,
        },
      ],
    };

    const options = {
      maintainAspectRatio: false,
      legend: {
        display: false,
      },
      cutoutPercentage: 80,
    };

    //percentage
    const showPercentageText = (number) => {
      if (number === null) {
        return "0%";
      }
      if (Math.sign(number) === 1) {
        return "+" + number.toFixed(0) + "%";
      }
      return number.toFixed(0) + "%";
    };

    return (
      <Card mb={3}>
        <CardHeader
          action={
            <IconButton aria-label="settings">
              <MoreVertical />
            </IconButton>
          }
          title="Havi eladások"
        />

        <CardContent>
          <ChartWrapper>
            <DoughnutInner variant="h4">
              <Typography variant="h4">
                {showPercentageText(salesinfo.rows.month.quantityPercent)}
              </Typography>
              <Typography variant="caption">eladások</Typography>
            </DoughnutInner>
            <Doughnut data={data} options={options} />
          </ChartWrapper>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell>Csomagok</TableCell>
                <TableCell align="right">Darabszám</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              <TableRow>
                <TableCell component="th" scope="row">
                  Összes
                </TableCell>
                <TableCell align="right">
                  {salesinfo.rows.month.quantity}
                </TableCell>
              </TableRow>
              <TableRow>
                <TableCell component="th" scope="row">
                  3 Havi
                </TableCell>
                <TableCell align="right">
                  {salesinfo.rows.month.package.threeMonth}
                </TableCell>
              </TableRow>
              <TableRow>
                <TableCell component="th" scope="row">
                  6 Havi
                </TableCell>
                <TableCell align="right">
                  {salesinfo.rows.month.package.sixMonth}
                </TableCell>
              </TableRow>
              <TableRow>
                <TableCell component="th" scope="row">
                  12 Havi
                </TableCell>
                <TableCell align="right">
                  {salesinfo.rows.month.package.twelveMonth}
                </TableCell>
              </TableRow>
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    );
  }
};

export default withTheme(DoughnutChart);
