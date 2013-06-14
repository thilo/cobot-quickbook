def stub_space_response(space_id, attributes = {})
  stub_request(:get, "http://www.cobot.me/api/spaces/#{space_id}").to_return(
    :status => 200,
    :body => {name: "Stub Space", id: "space-#{space_id}", url: "http://#{space_id}.cobot.me", description: "A coworking space in Berlin Kreuzberg.", owner_id: "user-langalex", website: "http://co-up.de", time_zone_name: "Europe/Berlin", time_zone_offset: 1, country: "Germany", :'tax-rate' => 19.0, display_price: "gross"}.deep_merge(attributes.symbolize_keys).to_json,
  )
end

def stub_plans_response_for_space(space_id, plans = nil)
  stub_request(:get, "http://#{space_id}.cobot.me/api/plans").to_return(
    :status => 200,
    :body => (plans || [{
      name: "basic", price_per_cycle: "100.0", cycle_duration: 1, currency: "EUR", description: "basic plan",
      day_pass_price: "10.0", cancellation_period: 30, hidden: false,
      time_passes: []
    }]).to_json
  )
end

def stub_invoices_response_for_space(space_id, invoices = nil)
  stub_request(:get, "http://#{space_id}.cobot.me/api/invoices").to_return(
    :status => 200,
    :body => ([{
      created_at: "2012-01-01",
      currency: "EUR",
      id: "cc7e75473a6911587b63d78f4e3f8eba",
      membership_id: "a9f6bcbed420c37539fa1257e66fd66b",
      address: {
          name: "joe doe",
          address: "1 broadway",
          company: "joe inc.",
          post_code: "94153",
          city: "atlantis",
          country: "ocean",
          state: "AT"
      },
      space_address: {
          name: "john space",
          address: "2 coworking way",
          company: "space inc.",
          post_code: "37521",
          city: "new atlantis",
          country: "oceanis",
          state: "AL"

      },
      invoice_text: "pay now",
      tax_rate: "20.0",
      invoice_number: 100,
      items: [
      {
          amount: "80.0",
          description: "monthly rent",
          quantity: "2.0",
          tax_rate: "20.0"
      },
      {
          amount: "20.0",
          description: "2 time passes",
          quantity: "2.0",
          tax_rate: "20.0"
      }
      ],
      total_amount: "240.0",
      total_amount_without_taxes: "200.0",
      tax_amounts: {'20.0' => "40.0"},
      url: "http://some-space.cobot.me/api/invoices/100",
      paid: false
    }]).to_json
  )
end

