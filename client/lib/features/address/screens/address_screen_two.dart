import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/address/services/address_services.dart';
import 'package:amazon_clone/features/auth/presentation/utitls/auth_extensions.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

import '../../../constants/global_variables.dart';
import '../../../core/common/widgets/basics.dart';
import '../../../core/common/widgets/custom_text_field.dart';
import '../../../models/product.dart';

class AddressScreenTwo extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  final Product product;

  const AddressScreenTwo(
      {super.key, required this.totalAmount, required this.product});

  @override
  State<AddressScreenTwo> createState() => _AddressScreenTwoState();
}

class _AddressScreenTwoState extends State<AddressScreenTwo>
    with CommonWidgets {
  final _addressFormKey = GlobalKey<FormState>();
  final AddressServices addressServices = AddressServices();
  String addressToBeUsed = '';
  final List<PaymentItem> _paymentItems = [];

  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();

  @override
  void initState() {
    _paymentItems.add(PaymentItem(
      amount: widget.totalAmount,
      label: 'Total Amount',
      status: PaymentItemStatus.final_price,
    ));
    super.initState();
  }

  @override
  void dispose() {
    flatBuildingController.dispose();
    areaController.dispose();
    cityController.dispose();
    pinCodeController.dispose();
    super.dispose();
  }

  void onApplePayResult(paymentResult) {
    if (context.currentUser.address.isEmpty) {
      addressServices.saveUserAddress(
          context: context, address: addressToBeUsed);
    }
    addressServices.buyNow(
      context: context,
      address: addressToBeUsed,
      product: widget.product,
      quantity: 1,
    );
  }

  void onGooglePayResult(paymentResult) {
    if (context.currentUser.address.isEmpty) {
      addressServices.saveUserAddress(
          context: context, address: addressToBeUsed);
    }
    addressServices.buyNow(
      context: context,
      address: addressToBeUsed,
      product: widget.product,
      quantity: 1,
    );
  }

  void payPressed(String addressFromProvider) {
    addressToBeUsed = '';

    bool isForm = flatBuildingController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pinCodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;

    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            '${flatBuildingController.text}, ${areaController.text}, ${pinCodeController.text}, ${cityController.text}';
      } else {
        throw Exception('Please enter all the details');
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      showSnackBar(context, 'ERROR');
    }
  }

  @override
  Widget build(BuildContext context) {
    var address = context.currentUser.address;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            flexibleSpace: Container(
              decoration:
                  const BoxDecoration(gradient: GlobalVariables.appBarGradient),
            ),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace(height: 12),
              Text(
                'Delivering to ${context.currentUser.name}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              verticalSpace(height: 12),
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10)
                            // border: Border.all(color: Colors.black12),
                            ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.black45,
                            ),
                            horizontalSpace(width: 12),
                            Text(
                              address,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        )),
                    verticalSpace(height: 20),
                    const Text(
                      'OR',
                      style: TextStyle(fontSize: 18),
                    ),
                    verticalSpace(height: 20),
                  ],
                ),
              const Text(
                ' Add a new address',
                style: TextStyle(fontSize: 15),
              ),
              verticalSpace(height: 8),
              Form(
                  key: _addressFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: flatBuildingController,
                        hintText: 'Flat, House no, Building ',
                      ),
                      verticalSpace(height: 10),
                      CustomTextField(
                        controller: areaController,
                        hintText: 'Area, Street',
                      ),
                      verticalSpace(height: 10),
                      CustomTextField(
                        controller: pinCodeController,
                        hintText: 'Pin code',
                      ),
                      verticalSpace(height: 10),
                      CustomTextField(
                        controller: cityController,
                        hintText: 'Town/City',
                      ),
                      verticalSpace(height: 10),
                      ApplePayButton(
                        paymentConfiguration:
                            PaymentConfiguration.fromJsonString('''{
    "provider": "apple_pay",
    "data": {
      "merchantIdentifier": "merchant.com.sams.fish",
      "displayName": "Sam's Fish",
      "merchantCapabilities": ["3DS", "debit", "credit"],
      "supportedNetworks": ["amex", "visa", "discover", "masterCard"],
      "countryCode": "US",
      "currencyCode": "USD",
      "requiredBillingContactFields": ["post"],
      "requiredShippingContactFields": ["post", "phone", "email", "name"],
      "shippingMethods": [
        {
          "amount": "0.00",
          "detail": "Available within an hour",
          "identifier": "in_store_pickup",
          "label": "In-Store Pickup"
        },
        {
          "amount": "4.99",
          "detail": "5-8 Business Days",
          "identifier": "flat_rate_shipping_id_2",
          "label": "UPS Ground"
        },
        {
          "amount": "29.99",
          "detail": "1-3 Business Days",
          "identifier": "flat_rate_shipping_id_1",
          "label": "FedEx Priority Mail"
        }
      ]
    }
  }'''),
                        paymentItems: _paymentItems,
                        style: ApplePayButtonStyle.black,
                        type: ApplePayButtonType.buy,
                        margin: const EdgeInsets.only(top: 15.0),
                        onPaymentResult: onApplePayResult,
                        loadingIndicator: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  )),
              GooglePayButton(
                onPressed: () {
                  payPressed(address);
                },
                paymentConfiguration: PaymentConfiguration.fromJsonString('''
              {
                "provider": "google_pay",
                "data": {
                  "environment": "TEST",
                  "apiVersion": 2,
                  "apiVersionMinor": 0,
                  "allowedPaymentMethods": [
                    {
                      "type": "CARD",
                      "tokenizationSpecification": {
                        "type": "PAYMENT_GATEWAY",
                        "parameters": {
                          "gateway": "example",
                          "gatewayMerchantId": "exampleGatewayMerchantId"
                        }
                      },
                      "parameters": {
                        "allowedCardNetworks": ["VISA", "MASTERCARD"],
                        "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
                        "billingAddressRequired": true,
                        "billingAddressParameters": {
                          "format": "FULL",
                          "phoneNumberRequired": true
                        }
                      }
                    }
                  ],
                  "merchantInfo": {
                    "merchantName": "Example Merchant Name"
                  },
                  "transactionInfo": {
                    "countryCode": "US",
                    "currencyCode": "USD"
                  }
                }
              }
              '''),
                paymentItems: _paymentItems,
                width: double.infinity,
                cornerRadius: 10,
                // cornerRadius = RawGooglePayButton.defaultButtonHeight ~/ 2,
                type: GooglePayButtonType.buy,
                margin: const EdgeInsets.only(top: 15.0),
                onPaymentResult: onGooglePayResult,
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              verticalSpace(height: 10),
              ApplePayButton(
                paymentConfiguration: PaymentConfiguration.fromJsonString('''{
    "provider": "apple_pay",
    "data": {
      "merchantIdentifier": "merchant.com.sams.fish",
      "displayName": "Sam's Fish",
      "merchantCapabilities": ["3DS", "debit", "credit"],
      "supportedNetworks": ["amex", "visa", "discover", "masterCard"],
      "countryCode": "US",
      "currencyCode": "USD",
      "requiredBillingContactFields": ["post"],
      "requiredShippingContactFields": ["post", "phone", "email", "name"],
      "shippingMethods": [
        {
          "amount": "0.00",
          "detail": "Available within an hour",
          "identifier": "in_store_pickup",
          "label": "In-Store Pickup"
        },
        {
          "amount": "4.99",
          "detail": "5-8 Business Days",
          "identifier": "flat_rate_shipping_id_2",
          "label": "UPS Ground"
        },
        {
          "amount": "29.99",
          "detail": "1-3 Business Days",
          "identifier": "flat_rate_shipping_id_1",
          "label": "FedEx Priority Mail"
        }
      ]
    }
  }'''),
                paymentItems: _paymentItems,
                onPressed: () {
                  payPressed(address);
                },
                style: ApplePayButtonStyle.black,
                type: ApplePayButtonType.buy,
                margin: const EdgeInsets.only(top: 15.0),
                onPaymentResult: onApplePayResult,
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
