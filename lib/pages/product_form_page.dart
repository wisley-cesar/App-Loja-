import 'package:flutter/material.dart';
import 'package:loja/models/product.dart';
import 'package:loja/models/product_list.dart';
import 'package:provider/provider.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();

  final _imageUrlFocus = FocusNode();
  final _imagemUrlController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  final _formDate = Map<String, Object>();

  bool _isLoading = false;

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;

    return isValidUrl;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formDate.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        final product = arg as Product;
        _formDate['id'] = product.id;
        _formDate['name'] = product.name;
        _formDate['price'] = product.price;
        _formDate['description'] = product.description;
        _formDate['imageUrl'] = product.imageUrl;

        _imagemUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(upDateImage);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.dispose();
    _imageUrlFocus.removeListener(upDateImage);
  }

  void upDateImage() {
    setState(() {});
  }

  Future<void> _submitForm() async {
    final _isValid = _formkey.currentState?.validate() ?? false;

    if (!_isValid) {
      return;
    }
    _formkey.currentState?.save();

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<ProductList>(
        context,
        listen: false,
      ).sabeProduct(_formDate);
      Navigator.of(context).pop();
    } catch (error) {
      if (context.mounted) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Ocorreu um erro'),
            content: const Text('Ocorreu um erro para salvar o produto.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'))
            ],
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
      if (context.mounted) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Produto '),
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formkey,
                child: ListView(
                  children: [
                    // Nome
                    TextFormField(
                      initialValue: _formDate['name']?.toString(),
                      decoration: const InputDecoration(labelText: 'Nome'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocus),
                      onSaved: (name) => _formDate['name'] = name ?? '',
                      //Validação
                      validator: (_name) {
                        final name = _name ?? '';
                        if (name.trim().isEmpty) {
                          return 'O nome é obrigatório.';
                        }
                        if (name.trim().length < 3) {
                          return 'O nome precisa no mínimo de 3 letras. ';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      // Preço
                      initialValue: _formDate['price']?.toString(),
                      decoration: const InputDecoration(labelText: 'Preço'),
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocus,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocus),
                      onSaved: (price) =>
                          _formDate['price'] = double.parse(price ?? '0'),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      // validação
                      validator: (_price) {
                        final priceString = _price ?? '';
                        final price = double.tryParse(priceString) ?? -1;

                        if ((price) <= 0) {
                          return 'Informe um preço valido';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      //Descrição
                      initialValue: _formDate['description']?.toString(),
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_imageUrlFocus),
                      onSaved: (description) =>
                          _formDate['description'] = description ?? '',
                      focusNode: _descriptionFocus,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,

                      //Validação
                      validator: (_description) {
                        final description = _description ?? '';
                        if (description.trim().isEmpty) {
                          return 'A descrição é obrigatório.';
                        }
                        if (description.trim().length < 10) {
                          return 'A descrição  precisa no mínimo de 10 letras. ';
                        }

                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            // Url
                            decoration: const InputDecoration(
                                labelText: 'Url da Imagem'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocus,
                            controller: _imagemUrlController,
                            onFieldSubmitted: (_) => _submitForm(),
                            onSaved: (imageUrl) =>
                                _formDate['imageUrl'] = imageUrl ?? '',

                            //Validação
                            validator: (_imageUrl) {
                              final imageUrl = _imageUrl ?? '';
                              if (!isValidImageUrl(imageUrl)) {
                                return 'Informe uma URL válida!';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          // imagem
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(
                            top: 10,
                            left: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: _imagemUrlController.text.isEmpty
                              ? const Text('Informe a Url')
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child:
                                      Image.network(_imagemUrlController.text),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
