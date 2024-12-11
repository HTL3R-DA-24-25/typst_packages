/// Converts a date to a german format, currently not implemented in typst.
#let format_date(date) = {
  let months = ("Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember")
  date.display("[day]. ") + months.at(date.month() - 1) + date.display(" [year]")
}

#let format_department(department) = {
  let departments = (
    IT: "Informationstechnologie/Netzwerktechnik",
    M: "Mechatronik",
  )
  departments.at(department)
}
