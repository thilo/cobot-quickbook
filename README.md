# info

A small application to import data from [Cobot](http://cobot.me) into [Quickbooks](http://quickbooks.intuit.com/). It takes care of creating products from your plans and resources as well as imports your customers into Quickbooks. Invoiced items will be added into your QB account with a delay of 7 days to allow corrections.

## Features:

* Assigning income to one Quickbooks income account
* Creating Quickbooks customers/items/invoices from the data in cobot
* Updating changes on cobot memberships to Quickbooks customer
* Ability to pause and resume syncing for a space


## Know Issues

* Only allow to set it to one income account per space
* Error when multiple users try to setup the same account
* Sometimes the QB API throws errors that the app does not handle well