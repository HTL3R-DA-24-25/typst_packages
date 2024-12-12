/// Converts a date to a german format, currently not implemented in typst.
#let format_date(date) = {
  let months = ("Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember")
  date.display("[day]. ") + months.at(date.month() - 1) + date.display(" [year]")
}

#let format_department(department) = {
  let departments = (
    ITN: "Informationstechnologie/Netzwerktechnik",
    ITM: "Informationstechnologie/Medientechnik",
    M: "Mechatronik",
  )
  departments.at(department)
}

/// Creates a completly blank page, useful for book binding
#let blank_page() = {
  page(header: none, footer: none, [])
}
