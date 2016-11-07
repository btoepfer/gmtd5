class TaskList extends React.Component {
  constructor() {
    super();
    this.props = {
      tasks: Array(2).fill("menu-off")
    };
    
  }
  render() {
      return (
      <div>
        <Task id={1} title={"My first Task"} content={"this.props.post.content"} />
        <Task id={2} title={"My second Task"} content={"this.props.post.content"} />
      </div>
      );
  }
};
