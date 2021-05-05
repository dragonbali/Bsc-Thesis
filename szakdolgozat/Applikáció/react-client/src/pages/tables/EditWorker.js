import React, { useEffect, useState } from "react";
import axios from "axios";
import { API_URL } from "../../constants";

import styled from "styled-components/macro";
import { useLocation } from "react-router-dom";

import Swal from "sweetalert2";

import {
  Button as MuiButton,
  Card as MuiCard,
  CardContent,
  Grid,
  TextField as MuiTextField,
  Typography,
  Switch,
} from "@material-ui/core";

import { spacing } from "@material-ui/system";

const Card = styled(MuiCard)(spacing);

const TextField = styled(MuiTextField)(spacing);

const Button = styled(MuiButton)(spacing);

function EditWorker() {
  function useQuery() {
    return new URLSearchParams(useLocation().search);
  }

  let query = useQuery();
  const workerId = query.get("id");
  //sates
  const [reload, setReload] = React.useState(false);
  //api
  const [error, setError] = useState(null);
  const [isLoaded, setIsLoaded] = useState(false);
  const [worker, setWorker] = useState([]);
  useEffect(() => {
    const fetchData = async () => {
      setIsLoaded(false);
      try {
        const [worker] = await axios.all([
          axios.get(API_URL + window.location.pathname),
        ]);
        setWorker(worker.data.rows[0]);
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
    const handleInputChange = (event) => {
      worker[event.target.name] = event.target.value;
      reload ? setReload(false) : setReload(true);
    };
    const handleSwitchChange = (event) => {
      worker[event.target.name] = event.target.checked;
      reload ? setReload(false) : setReload(true);
    };

    const handleSubmitButton = (ThisWorker) => {
      axios
        .put(`${API_URL}/workers/update/worker/${ThisWorker.id}`, ThisWorker)
        .then(() => {
          Swal.fire({
            icon: "success",
            title: "Mentve",
            showConfirmButton: false,
            timer: 1000,
          });
        });
      reload ? setReload(false) : setReload(true);
    };

    return (
      <Card mb={6}>
        <CardContent>
          <Typography variant="h6" gutterBottom>
            Worker
          </Typography>
          <Typography variant="body2" gutterBottom>
            Itt tudod módosítani a Mester adatait.
          </Typography>
          <Grid container spacing={4}>
            <Grid item md={4}>
              <TextField
                name="name"
                label="Név"
                value={worker.name}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                variant="outlined"
                autoComplete="new-password"
                my={2}
              />
            </Grid>
            <Grid item md={2}>
              <TextField
                name="phone"
                label="Telefonszám"
                value={worker.phone}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                variant="outlined"
                autoComplete="new-password"
                my={2}
              />
            </Grid>
            <Grid item md={2}>
              <TextField
                name="registration_number"
                label="Nyilvántart. szám"
                value={worker.registration_number}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                variant="outlined"
                autoComplete="new-password"
                my={2}
              />
            </Grid>
            <Grid item md={4}>
              <TextField
                name="email"
                label="Email"
                value={worker.email}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                type="email"
                variant="outlined"
                my={2}
              />
            </Grid>
          </Grid>
          <Grid container spacing={4}>
            <Grid item md={2}>
              <TextField
                name="priority"
                label="Prioritás"
                value={worker.priority}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                variant="outlined"
                type="number"
                autoComplete="new-password"
                my={2}
              />
            </Grid>
            <Grid item md={2}>
              <TextField
                name="location_id"
                label="Elhelyezkedés ID"
                value={worker.location_id}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                variant="outlined"
                type="number"
                autoComplete="new-password"
                my={2}
              />
            </Grid>
            <Grid item md={4}>
              <TextField
                name="website"
                label="Website"
                value={worker.website}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                variant="outlined"
                autoComplete="new-password"
                my={2}
              />
            </Grid>
          </Grid>
          <Grid container spacing={12}>
            <Grid item md={2}>
              <span>Highlight</span>
              <Switch
                name="highlight"
                checked={worker.highlight}
                onChange={(event) => {
                  handleSwitchChange(event);
                }}
              />
            </Grid>
            <Grid item md={2}>
              <span>Visible</span>
              <Switch
                name="visible"
                checked={worker.visible}
                onChange={(event) => {
                  handleSwitchChange(event);
                }}
              />
            </Grid>
            <Grid item md={2}>
              <span>Payed plan</span>
              <Switch
                name="payed_plan"
                checked={worker.payed_plan}
                onChange={(event) => {
                  handleSwitchChange(event);
                }}
              />
            </Grid>
            <Grid item md={2}>
              <span>Can issue invoice</span>
              <Switch
                name="can_issue_invoice"
                checked={worker.can_issue_invoice}
                onChange={(event) => {
                  handleSwitchChange(event);
                }}
              />
            </Grid>
          </Grid>
          <TextField
            name="description"
            label="Leírás"
            value={worker.description}
            fullWidth
            onChange={(event) => {
              handleInputChange(event);
            }}
            multiline
            variant="outlined"
            my={2}
          />

          <Button
            type="submit"
            variant="contained"
            color="primary"
            onClick={() => {
              handleSubmitButton(worker);
            }}
            mt={3}
          >
            Mentés
          </Button>
        </CardContent>
      </Card>
    );
  }
}

export default EditWorker;
