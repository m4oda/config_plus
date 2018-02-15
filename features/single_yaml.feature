# language: en
Feature: ConfigPlus Generates from A Single YAML file
  Background:
    Given a YAML file named `example.yml' with data:
      """
      service:
        name: foo
      host:
        - name: web
          address: 10.5.0.1
        - name: batch
          address: 10.5.0.5
        - name: database
          address: 10.5.0.8
      """
  Scenario: Generate ConfigPlus with its configure method
    When we add a code block for setting:
      """
      config.root_dir = @root_dir
      config.source = 'example.yml'
      """
    Then ConfigPlus.root has data
    And ConfigPlus.root has a key `service'
    And ConfigPlus.root.service has a key `name'
    And ConfigPlus.root.service.name returns a string `foo'
    And ConfigPlus.root has a key `host'
    And ConfigPlus.root.host returns an array data
    And ConfigPlus.root.host.first.name returns a string `web'
    And ConfigPlus.root.host.first.address returns a string `10.5.0.1'

