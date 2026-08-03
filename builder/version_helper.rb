# frozen_string_literal: true

require 'date'

module VersionHelper
  VERSIONS = [
    { version: 'Pre',  start: '2021-01-01', end: '2021-10-26' },
    { version: '0.60', start: '2021-10-27', end: '2022-05-24' },
    { version: '0.70', start: '2022-05-25', end: '2023-02-09' },
    { version: '0.90', start: '2023-02-10', end: '2023-04-25' },
    { version: '1.0',  start: '2023-04-26', end: '2023-06-06' },
    { version: '1.1',  start: '2023-06-07', end: '2023-07-18' },
    { version: '1.2',  start: '2023-07-19', end: '2023-08-29' },
    { version: '1.3',  start: '2023-08-30', end: '2023-10-10' },
    { version: '1.4',  start: '2023-10-11', end: '2023-11-14' },
    { version: '1.5',  start: '2023-11-15', end: '2023-12-26' },
    { version: '1.6',  start: '2023-12-27', end: '2024-02-05' },
    { version: '2.0',  start: '2024-02-06', end: '2024-03-26' },
    { version: '2.1',  start: '2024-03-27', end: '2024-05-07' },
    { version: '2.2',  start: '2024-05-08', end: '2024-06-18' },
    { version: '2.3',  start: '2024-06-19', end: '2024-07-30' },
    { version: '2.4',  start: '2024-07-31', end: '2024-09-09' },
    { version: '2.5',  start: '2024-09-10', end: '2024-10-22' },
    { version: '2.6',  start: '2024-10-23', end: '2024-12-03' },
    { version: '2.7',  start: '2024-12-04', end: '2025-01-14' },
    { version: '3.0',  start: '2025-01-15', end: '2025-02-25' },
    { version: '3.1',  start: '2025-02-26', end: '2025-04-08' },
    { version: '3.2',  start: '2025-04-09', end: '2025-05-20' },
    { version: '3.3',  start: '2025-05-21', end: '2025-07-01' },
    { version: '3.4',  start: '2025-07-02', end: '2025-08-12' },
    { version: '3.5',  start: '2025-08-13', end: '2025-09-23' },
    { version: '3.6',  start: '2025-09-24', end: '2025-11-04' },
    { version: '3.7',  start: '2025-11-05', end: '2025-12-16' },
    { version: '3.8',  start: '2025-12-17', end: '2026-02-12' },
    { version: '4.0',  start: '2026-02-13', end: '2026-03-24' },
    { version: '4.1',  start: '2026-03-25', end: '2026-04-21' },
    { version: '4.2',  start: '2026-04-22', end: '2026-05-31' },
    { version: '4.3',  start: '2026-06-01', end: '2026-07-14' },
    { version: '4.4',  start: '2026-07-15', end: Date.today.to_s }
  ].freeze

  def self.check(date)
    target = Date.parse(date)

    VERSIONS.find do |version|
      target >= Date.parse(version[:start]) &&
        target <= Date.parse(version[:end])
    end&.dig(:version)
  end
end
