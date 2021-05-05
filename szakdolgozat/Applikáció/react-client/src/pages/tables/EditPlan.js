import React, { useEffect, useState } from "react";
import axios from "axios";
import { API_URL } from "../../constants";

import styled from "styled-components/macro";

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

function EditPlan() {
  //sates
  const [reload, setReload] = React.useState(false);
  //api
  const [error, setError] = useState(null);
  const [isLoaded, setIsLoaded] = useState(false);
  const [plan, setPlan] = useState([]);
  useEffect(() => {
    const fetchData = async () => {
      setIsLoaded(false);
      try {
        const [plan] = await axios.all([
          axios.get(API_URL + window.location.pathname),
        ]);
        setPlan(plan.data.rows[0]);
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
      plan[event.target.name] = event.target.value;
      reload ? setReload(false) : setReload(true);
    };
    const handleSwitchChange = (event) => {
      plan[event.target.name] = event.target.checked;
      reload ? setReload(false) : setReload(true);
    };

    const handleSubmitButton = (ThisPlan) => {
      axios
        .put(`${API_URL}/plans/update/plan/${ThisPlan.id}`, ThisPlan)
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
            Plan
          </Typography>
          <Typography variant="body2" gutterBottom>
            Itt tudod módosítani a plan adatait.
          </Typography>
          <Grid container spacing={4}>
            <Grid item md={2}>
              <TextField
                name="name"
                label="Név"
                value={plan.name}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                variant="outlined"
                autoComplete="new-password"
                my={2}
              />
            </Grid>
            <Grid item md={3}>
              <TextField
                name="description"
                label="Leírás"
                value={plan.description}
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
                name="sku"
                label="sku"
                value={plan.sku}
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
                name="price"
                label="Ár"
                value={plan.price}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                type="number"
                variant="outlined"
                my={2}
              />
            </Grid>
            <Grid item md={3}>
              <TextField
                name="type"
                label="Type"
                value={plan.type}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                variant="outlined"
                my={2}
              />
            </Grid>
          </Grid>
          <Grid container spacing={4}>
            <Grid item md={2}>
              <TextField
                name="duration_in_hours"
                label="Időtartam órában"
                value={plan.duration_in_hours}
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
                name="balance_to_add"
                label="Egyenleg hozzáad."
                value={plan.balance_to_add}
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
            <Grid item md={3}>
              <TextField
                name="stripe_price_id"
                label="stripe_price_id"
                value={plan.stripe_price_id}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                variant="outlined"
                my={2}
              />
            </Grid>
            <Grid item md={3}>
              <TextField
                name="stripe_product_id"
                label="stripe_product_id"
                value={plan.stripe_product_id}
                fullWidth
                onChange={(event) => {
                  handleInputChange(event);
                }}
                variant="outlined"
                my={2}
              />
            </Grid>
          </Grid>
          <Grid container spacing={12}>
            <Grid item md={2}>
              <span>Látható</span>
              <Switch
                name="visible"
                checked={plan.visible}
                onChange={(event) => {
                  handleSwitchChange(event);
                }}
              />
            </Grid>
            <Grid item md={2}>
              <span>Boosts First Place</span>
              <Switch
                name="boosts_first_place"
                checked={plan.boosts_first_place}
                onChange={(event) => {
                  handleSwitchChange(event);
                }}
              />
            </Grid>
          </Grid>
          <Button
            type="submit"
            variant="contained"
            color="primary"
            onClick={() => {
              handleSubmitButton(plan);
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

export default EditPlan;
