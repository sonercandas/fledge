"""Test power flow solvers."""

import matplotlib.pyplot as plt
import numpy as np
import os
import pandas as pd
from parameterized import parameterized
import scipy.sparse
import time
import unittest

import fledge.config
import fledge.electric_grid_models
import fledge.power_flow_solvers

logger = fledge.config.get_logger(__name__)

as_complex = np.vectorize(np.complex)  # Utility function to convert strings in numpy array to complex numbers.


class TestPowerFlowSolvers(unittest.TestCase):

    @parameterized.expand([
        ("1",),
        ("2",),
        ("3",),
    ])
    def test_get_voltage_fixed_point_1(self, test_index):
        # Obtain test data.
        path = os.path.join(fledge.config.test_data_path, 'test_get_voltage_vector_' + test_index)
        admittance_matrix = scipy.sparse.csr_matrix(as_complex(
            pd.read_csv(os.path.join(path, 'admittance_matrix.csv'), header=None, dtype=str).values
        ))
        transformation_matrix = scipy.sparse.csr_matrix(as_complex(
            pd.read_csv(os.path.join(path, 'transformation_matrix.csv'), header=None).values
        ))
        power_vector_wye = as_complex(
            pd.read_csv(os.path.join(path, 'power_vector_wye.csv'), header=None, dtype=str).values
        )
        power_vector_delta = as_complex(
            pd.read_csv(os.path.join(path, 'power_vector_delta.csv'), header=None, dtype=str).values
        )
        voltage_vector_no_load = as_complex(
            pd.read_csv(os.path.join(path, 'voltage_vector_no_load.csv'), header=None, dtype=str).values
        )
        voltage_vector_solution = as_complex(
            pd.read_csv(os.path.join(path, 'voltage_vector_solution.csv'), header=None, dtype=str).values
        )

        # Define expected result.
        expected = abs(voltage_vector_solution[3:])

        # Get actual result.
        time_start = time.time()
        actual = abs(fledge.power_flow_solvers.get_voltage_fixed_point(
            admittance_matrix[3:, 3:],
            transformation_matrix[3:, 3:],
            power_vector_wye[3:],
            power_vector_delta[3:],
            np.zeros(power_vector_wye[3:].shape),
            np.zeros(power_vector_delta[3:].shape),
            voltage_vector_no_load[3:],
            voltage_vector_no_load[3:]
        ))
        time_duration = time.time() - time_start
        logger.info(
            f"Test get_voltage_fixed_point #1.{test_index}: Completed in {time_duration:.6f} seconds."
        )

        # Compare expected and actual.
        np.testing.assert_array_almost_equal(actual, expected, decimal=0)

    def test_get_voltage_fixed_point_2(self):
        # Obtain test data.
        electric_grid_model = fledge.electric_grid_models.ElectricGridModel(fledge.config.test_scenario_name)

        # Get result.
        time_start = time.time()
        fledge.power_flow_solvers.get_voltage_fixed_point(electric_grid_model)
        time_duration = time.time() - time_start
        logger.info(f"Test get_voltage_fixed_point #2: Completed in {time_duration:.6f} seconds.")

    def test_get_voltage_opendss(self):
        # Initialize OpenDSS model.
        fledge.electric_grid_models.initialize_opendss_model(fledge.config.test_scenario_name)

        # Get result.
        time_start = time.time()
        fledge.power_flow_solvers.get_voltage_opendss()
        time_duration = time.time() - time_start
        logger.info(f"Test get_voltage_opendss: Completed in {time_duration:.6f} seconds.")

    def test_get_branch_power_fixed_point(self):
        # Obtain test data.
        electric_grid_model = fledge.electric_grid_models.ElectricGridModel(fledge.config.test_scenario_name)
        node_voltage_vector = fledge.power_flow_solvers.get_voltage_fixed_point(electric_grid_model)

        # Get result.
        time_start = time.time()
        fledge.power_flow_solvers.get_branch_power_fixed_point(
            electric_grid_model,
            node_voltage_vector
        )
        time_duration = time.time() - time_start
        logger.info(f"Test get_branch_power_fixed_point: Completed in {time_duration:.6f} seconds.")

    def test_get_branch_power_opendss(self):
        # Initialize OpenDSS model.
        fledge.electric_grid_models.initialize_opendss_model(fledge.config.test_scenario_name)

        # Get result.
        time_start = time.time()
        fledge.power_flow_solvers.get_branch_power_opendss()
        time_duration = time.time() - time_start
        logger.info(f"Test get_branch_power_opendss: Completed in {time_duration:.6f} seconds.")

    def test_get_loss_fixed_point(self):
        # Obtain test data.
        electric_grid_model = fledge.electric_grid_models.ElectricGridModel(fledge.config.test_scenario_name)
        node_voltage_vector = fledge.power_flow_solvers.get_voltage_fixed_point(electric_grid_model)

        # Get result.
        time_start = time.time()
        fledge.power_flow_solvers.get_loss_fixed_point(
            electric_grid_model,
            node_voltage_vector
        )
        time_duration = time.time() - time_start
        logger.info(f"Test get_loss_fixed_point: Completed in {time_duration:.6f} seconds.")

    def test_get_loss_opendss(self):
        # Initialize OpenDSS model.
        fledge.electric_grid_models.initialize_opendss_model(fledge.config.test_scenario_name)

        # Get result.
        time_start = time.time()
        fledge.power_flow_solvers.get_loss_opendss()
        time_duration = time.time() - time_start
        logger.info(f"Test get_loss_opendss: Completed in {time_duration:.6f} seconds.")

    def test_power_flow_solution_fixed_point_1(self):
        # Get result.
        time_start = time.time()
        fledge.power_flow_solvers.PowerFlowSolutionFixedPoint(fledge.config.test_scenario_name)
        time_duration = time.time() - time_start
        logger.info(f"Test PowerFlowSolutionFixedPoint #1: Completed in {time_duration:.6f} seconds.")

    def test_power_flow_solution_fixed_point_2(self):
        # Obtain test data.
        electric_grid_model = fledge.electric_grid_models.ElectricGridModel(fledge.config.test_scenario_name)
        node_voltage_vector_no_load = abs(electric_grid_model.node_voltage_vector_no_load)

        # Define expected result.
        fledge.electric_grid_models.initialize_opendss_model(fledge.config.test_scenario_name)
        node_voltage_vector_opendss = abs(fledge.power_flow_solvers.get_voltage_opendss())

        # Get result.
        time_start = time.time()
        node_voltage_vector_fixed_point = abs(
            fledge.power_flow_solvers.PowerFlowSolutionFixedPoint(fledge.config.test_scenario_name).node_voltage_vector
        )
        time_duration = time.time() - time_start
        logger.info(f"Test PowerFlowSolutionFixedPoint #2: Completed in {time_duration:.6f} seconds.")

        # Display results.
        if fledge.config.test_plots:
            comparison = pd.DataFrame(
                np.hstack([
                    node_voltage_vector_opendss / node_voltage_vector_no_load,
                    node_voltage_vector_fixed_point / node_voltage_vector_no_load]),
                index=electric_grid_model.nodes,
                columns=['OpenDSS', 'Fixed Point']
            )
            comparison.plot(kind='bar')
            plt.show(block=False)

            absolute_error = pd.DataFrame(
                (node_voltage_vector_fixed_point - node_voltage_vector_opendss) / node_voltage_vector_no_load,
                index=electric_grid_model.nodes,
                columns=['Absolute error']
            )
            absolute_error.plot(kind='bar')
            plt.show(block=False)

        # Compare expected and actual.
        # TODO: Enable result check.
        # np.testing.assert_array_almost_equal(node_voltage_vector_opendss, node_voltage_vector_fixed_point, decimal=0)


if __name__ == '__main__':
    unittest.main()
