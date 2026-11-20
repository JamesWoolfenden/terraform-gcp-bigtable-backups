locals {
  # Zero-or-one list so the optional vpc_access block can be rendered dynamically.
  vpc_access = var.vpc_access == null ? [] : [var.vpc_access]

  # The bundled backup script reads the project from "project"; the variable's
  # validation stops callers overriding it.
  container_env = merge(var.environment_variables, { project = var.project_id })
}
