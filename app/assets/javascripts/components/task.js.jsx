class Task extends React.Component {
  constructor() {
    super();
    this.props = {
    title: React.PropTypes.string,
    content: React.PropTypes.string,
    dueDate: React.PropTypes.string
    };
  }
  render() {
      return (
      <div className="task">
        <h5>{this.props.title}
          <TaskMenu/>
        </h5>
        <div>{this.props.content}</div>
        <div>Due Date: {this.props.dueDate}</div>
      </div>
      );
  }
};
