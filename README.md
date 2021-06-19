# Stripe

![Swift](http://img.shields.io/badge/swift-5.2-brightgreen.svg)
![Vapor](http://img.shields.io/badge/vapor-4.0-brightgreen.svg)


### Stripe is a Vapor helper to use [StripeKit](https://github.com/vapor-community/stripe-kit)

## Usage guide
In your `Package.swift` file, add the following

~~~~swift
.package(url: "https://github.com/vapor-community/stripe.git", from: "10.0.0")
~~~~


To use Stripe in your Vapor application, set the environment variable for you Stripe API key
~~~
export STRIPE_API_KEY="sk_123456"      
~~~

Now you can access a `StripeClient` via `Request`.
~~~~swift

struct ChargeToken: Content {
    var token: String
}

func chargeCustomer(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    return try req.content.decode(ChargeToken.self).flatMap { charge in
        return req.stripe.charge.create(amount: 2500, currency: .usd, source: charge.stripeToken).map { stripeCharge in
            if stripeCharge.status == .success {
                return .ok
            } else {
                print("Stripe charge status: \(stripeCharge.status.rawValue)")
                return .badRequest
            }
        }
    }
}
~~~~

## License

Stripe is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## Want to help?
Feel free to submit a pull request whether it's a clean up, a new approach to handling things, adding a new part of the API, or even if it's just a typo. All help is welcomed! 😀
