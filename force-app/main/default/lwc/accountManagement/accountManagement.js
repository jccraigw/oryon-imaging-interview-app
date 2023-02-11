import { LightningElement, track } from 'lwc';
import getAllActiveAccounts from '@salesforce/apex/AccountController.getAllActiveAccounts';

const actions = [{ label: 'Delete',  name: 'delete' }];
const columns=[
  {
    label: 'Name',
    fieldName: 'Name',
    wrapText: true
  },
  {
    type: 'action',
    typeAttributes: { rowActions: actions,
                      menuAlignment: 'auto' }
  }
];

export default class AccountManagement extends LightningElement {
  @track
  data = [];
  columns = columns;
  
  connectedCallback() {
    getAllActiveAccounts()
    .then (result => {
        if (!this.isBlank(result)) {
            this.data = result;
        } 
    })
    .catch(error => {
        console.log(error);
    })
  }

  handleRowAction(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;
    switch (actionName) {
        case 'delete':
            this.deleteRow(row);
            break;
        default:
    }
  }

  deleteRow(row) {
    const { Id } = row;
    const index = this.findRowIndexById(Id);
    if (index !== -1) {
        this.data = this.data
            .slice(0, index)
            .concat(this.data.slice(index + 1));
    }
  }

  findRowIndexById(Id) {
    let ret = -1;
    this.data.some((row, index) => {
        if (row.Id === Id) {
            ret = index;
            return true;
        }
        return false;
    });
    return ret;
  }

  isBlank(value) {
    return (typeof value === 'undefined' || value === null || value === '');
  }
}