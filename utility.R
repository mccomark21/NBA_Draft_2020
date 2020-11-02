# Loading Screen for charts----

loadingscreen <- function(plot){
  
  shinycssloaders::withSpinner(plot, type = 8, color = "#0072B2", size = 1.5, hide.ui = FALSE)
}