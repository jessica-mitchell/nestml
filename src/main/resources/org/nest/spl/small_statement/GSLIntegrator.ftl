<#--
  Generates a series of C++ statements which perform one integration step of
  all odes defined the neuron.
  @result C++ statements
-->
__t = 0;
// numerical integration with adaptive step size control:
// ------------------------------------------------------
// gsl_odeiv_evolve_apply performs only a single numerical
// integration step, starting from t and bounded by step;
// the while-loop ensures integration over the whole simulation
// step (0, step] if more than one integration step is needed due
// to a small integration step size;
// note that (t+IntegrationStep > step) leads to integration over
// (t, step] and afterwards setting t to step, but it does not
// enforce setting IntegrationStep to step-t; this is of advantage
// for a consistent and efficient integration across subsequent
// simulation intervals
while ( __t < B_.__step )
{
  const int status = gsl_odeiv_evolve_apply(B_.__e,
                                            B_.__c,
                                            B_.__s,
                                            &B_.__sys,              // system of ODE
                                            &__t,                   // from t
                                            B_.__step,              // to t <= step
                                            &B_.__integration_step, // integration step size
                                            S_.y);                 // neuronal state

  if ( status != GSL_SUCCESS ) {
    throw nest::GSLSolverFailure( get_name(), status );
  }
}