class TaskMenu extends React.Component {
  constructor() {
    super();
    this.state = {
      showMenu: "menu-off"
    }
  }
  toggleMenu() {
    var menu = "menu-on";
    if (this.state.showMenu === "menu-on")
      menu = "menu-off";
    this.setState({
      showMenu: menu
    })
  }
  render() {
    return (
      <span>
        <span className="task-menu">
          <a className="toggle-nav fa fa-bars" onClick={() => this.toggleMenu()}></a>
        </span>
        <div className={this.state.showMenu}>
          <h5>Menu</h5>
          <ul>
            <li>item 1</li>
            <li>item 2</li>
            <li>...</li>
          </ul>
        </div>
      </span>
    );
  }
}


