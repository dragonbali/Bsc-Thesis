import React, { useEffect, useState } from "react";
import styled from "styled-components/macro";

import axios from "axios";
import { API_URL } from "../../constants";
import Moment from "react-moment";

import {
  Card as MuiCard,
  CardHeader,
  IconButton,
  Chip as MuiChip,
  Paper as MuiPaper,
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableRow,
} from "@material-ui/core";

import { red, green, orange } from "@material-ui/core/colors";

import { spacing } from "@material-ui/system";

import { MoreVertical } from "react-feather";

const Card = styled(MuiCard)(spacing);

const Chip = styled(MuiChip)`
  height: 20px;
  padding: 4px 0;
  font-size: 90%;
  background: ${(props) => props.done && green[500]};
  background: ${(props) => props.processing && orange[700]};
  background: ${(props) => props.cancelled && red[500]};
  color: ${(props) => props.theme.palette.common.white};
`;

const Paper = styled(MuiPaper)(spacing);

const TableWrapper = styled.div`
  overflow-y: auto;
  max-width: calc(100vw - ${(props) => props.theme.spacing(12)}px);
`;

function DashboardTable() {
  const [error, setError] = useState(null);
  const [isLoaded, setIsLoaded] = useState(false);
  const [data, setData] = useState([]);
  useEffect(() => {
    const fetchData = async () => {
      setIsLoaded(false);
      try {
        const [billing] = await axios.all([
          axios.get(API_URL + "/info/sixbillings"),
        ]);
        setData(billing.data);
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
    const rows = data.rows;
    const showPrice = (id) => {
      for (let i = 0; i < data.rows.length; i++) {
        const element = data.rows[i];
        if (element.id === id) {
          let sum = 0;
          for (let j = 0; j < element.payment_prep_request.items.length; j++) {
            const element2 = element.payment_prep_request.items[j];
            sum += element2.quantity * element2.item_total;
          }
          return sum + " Ft";
        }
      }
    };
    return (
      <Card mb={6}>
        <CardHeader
          action={
            <IconButton aria-label="settings">
              <MoreVertical />
            </IconButton>
          }
          title="Legújabb eladások"
        />
        <Paper>
          <TableWrapper>
            <Table>
              <TableHead>
                <TableRow>
                  <TableCell>Név</TableCell>
                  <TableCell>Dátum</TableCell>
                  <TableCell>Összeg</TableCell>
                  <TableCell>Státusz</TableCell>
                  <TableCell>Fizetési Mód</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {rows.map((row) => (
                  <TableRow>
                    <TableCell component="th" scope="row">
                      {row.payment_prep_request.billing_address.name}
                    </TableCell>
                    <TableCell>
                      <Moment format="YYYY/MM/DD">{row.created_at}</Moment>
                    </TableCell>
                    <TableCell>{showPrice(row.id)}</TableCell>
                    <TableCell>
                      {row.completed === true && (
                        <Chip
                          size="small"
                          mr={1}
                          mb={1}
                          label="Elkészült"
                          done
                        />
                      )}
                      {row.payment_method === "bank transfer" &&
                        row.completed === false && (
                          <Chip
                            size="small"
                            mr={1}
                            mb={1}
                            label="Feldolgozás alatt"
                            processing
                          />
                        )}
                      {(row.payment_method === "barion" ||
                        row.payment_method === null) &&
                        row.completed === false && (
                          <Chip
                            size="small"
                            mr={1}
                            mb={1}
                            label="Félbehagyott"
                            cancelled
                          />
                        )}
                    </TableCell>
                    <TableCell>{row.payment_method}</TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </TableWrapper>
        </Paper>
      </Card>
    );
  }
}

export default DashboardTable;
