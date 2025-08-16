import 'package:flutter/material.dart';
import '../../../../constants/app_constants.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_text_field.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  final List<Map<String, dynamic>> _addresses = [
    {
      'id': '1',
      'title': 'Home',
      'address': '123 Main Street, Indiranagar, Bangalore, Karnataka 560038',
      'type': 'home',
      'isDefault': true,
    },
    {
      'id': '2',
      'title': 'Office',
      'address': '456 Tech Park, Whitefield, Bangalore, Karnataka 560066',
      'type': 'office',
      'isDefault': false,
    },
    {
      'id': '3',
      'title': 'Warehouse',
      'address': '789 Industrial Area, Peenya, Bangalore, Karnataka 560058',
      'type': 'other',
      'isDefault': false,
    },
  ];

  bool _isAddingAddress = false;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedType = 'home';

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _showAddAddressDialog() {
    _titleController.clear();
    _addressController.clear();
    _selectedType = 'home';
    _isAddingAddress = true;
    
    showDialog(
      context: context,
      builder: (context) => _buildAddressDialog(),
    );
  }

  void _showEditAddressDialog(Map<String, dynamic> address) {
    _titleController.text = address['title'];
    _addressController.text = address['address'];
    _selectedType = address['type'];
    _isAddingAddress = false;
    
    showDialog(
      context: context,
      builder: (context) => _buildAddressDialog(),
    );
  }

  Widget _buildAddressDialog() {
    return AlertDialog(
      title: Text(_isAddingAddress ? 'Add New Address' : 'Edit Address'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: _titleController,
              labelText: 'Address Title',
              hintText: 'e.g., Home, Office, Warehouse',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter address title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            CustomTextField(
              controller: _addressController,
              labelText: 'Full Address',
              hintText: 'Enter complete address',
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              initialValue: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Address Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'home', child: Text('Home')),
                DropdownMenuItem(value: 'office', child: Text('Office')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveAddress,
          child: Text(_isAddingAddress ? 'Add' : 'Save'),
        ),
      ],
    );
  }

  void _saveAddress() {
    if (!_formKey.currentState!.validate()) return;

    if (_isAddingAddress) {
      // Add new address
      final newAddress = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': _titleController.text,
        'address': _addressController.text,
        'type': _selectedType,
        'isDefault': _addresses.isEmpty,
      };
      
      setState(() {
        _addresses.add(newAddress);
      });
    } else {
      // Update existing address
      // TODO: Implement edit functionality
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isAddingAddress ? 'Address added successfully!' : 'Address updated successfully!'),
        backgroundColor: AppConstants.successColor,
      ),
    );
  }

  void _deleteAddress(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _addresses.removeWhere((address) => address['id'] == id);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Address deleted successfully!'),
                  backgroundColor: AppConstants.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _setDefaultAddress(String id) {
    setState(() {
      for (var address in _addresses) {
        address['isDefault'] = address['id'] == id;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Default address updated!'),
        backgroundColor: AppConstants.successColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Saved Addresses'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: AppConstants.secondaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Add Address Button
          Container(
            padding: const EdgeInsets.all(AppConstants.padding),
            child: CustomButton(
              onPressed: _showAddAddressDialog,
              text: 'Add New Address',
              icon: Icons.add_location,
            ),
          ),
          
          // Addresses List
          Expanded(
            child: _addresses.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.padding),
                    itemCount: _addresses.length,
                    itemBuilder: (context, index) {
                      final address = _addresses[index];
                      return _buildAddressCard(address);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 80,
            color: AppConstants.textSecondaryColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No saved addresses',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppConstants.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your frequently used addresses for quick booking',
            style: TextStyle(
              fontSize: 14,
              color: AppConstants.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(Map<String, dynamic> address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppConstants.secondaryColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: address['isDefault'] 
              ? AppConstants.primaryColor 
              : AppConstants.primaryColor.withOpacity(0.2),
          width: address['isDefault'] ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getAddressTypeIcon(address['type']),
            color: AppConstants.primaryColor,
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Text(
              address['title'],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimaryColor,
              ),
            ),
            if (address['isDefault']) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Default',
                  style: TextStyle(
                    color: AppConstants.secondaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          address['address'],
          style: const TextStyle(
            color: AppConstants.textSecondaryColor,
            fontSize: 14,
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _showEditAddressDialog(address);
                break;
              case 'default':
                _setDefaultAddress(address['id']);
                break;
              case 'delete':
                _deleteAddress(address['id']);
                break;
            }
          },
          itemBuilder: (context) => [
            if (!address['isDefault'])
              const PopupMenuItem(
                value: 'default',
                child: Row(
                  children: [
                    Icon(Icons.star, size: 20),
                    SizedBox(width: 8),
                    Text('Set as Default'),
                  ],
                ),
              ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getAddressTypeIcon(String type) {
    switch (type) {
      case 'home':
        return Icons.home;
      case 'office':
        return Icons.business;
      case 'other':
        return Icons.location_on;
      default:
        return Icons.location_on;
    }
  }
}
