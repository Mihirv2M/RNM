import './App.css';
import { useEffect, useState } from 'react';

function App() {
  const [form, setForm] = useState({ username: '', password: '' });
  const [users, setUsers] = useState([]);

  const handleForm = (e) => {
    setForm({
      ...form,
      [e.target.name]: e.target.value,
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await fetch('http://demoalbforserver-1819254553.us-east-1.elb.amazonaws.com:8080/health/demo', {
        method: 'POST',
        body: JSON.stringify(form),
        headers: {
          'Content-Type': 'application/json',
        },
      });
      if (response.ok) {
        const data = await response.json();
        console.log(data);
        getUsers(); // Refresh user list after form submission
      } else {
        console.error('Failed to submit form.');
      }
    } catch (error) {
      console.error('Error submitting form:', error);
    }
  };

  const getUsers = async () => {
    try {
      const response = await fetch('http://demoalbforserver-1819254553.us-east-1.elb.amazonaws.com:8080/test', {
        method: 'GET',
      });
      if (response.ok) {
        const data = await response.json();
        setUsers(data);
      } else {
        console.error('Failed to fetch users.');
      }
    } catch (error) {
      console.error('Error fetching users:', error);
    }
  };

  useEffect(() => {
    getUsers();
  }, []);

  return (
    <div className="app-container">
      <h1 className="app-title">Password Saver 🔒</h1>
      <form className="form" onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="username">Enter username:</label>
          <input
            id="username"
            type="text"
            name="username"
            value={form.username}
            onChange={handleForm}
            required
          />
        </div>
        <div className="form-group">
          <label htmlFor="password">Password:</label>
          <input
            id="password"
            type="password"
            name="password"
            value={form.password}
            onChange={handleForm}
            required
          />
        </div>
        <button type="submit" className="submit-button">Submit</button>
      </form>

      <div className="user-list">
        <h2>Users</h2>
        <ul>
          {users.map((user) => (
            <li key={user._id} className="user-item">
              <span className="username">{user.username}</span> - <span className="password">{user.password}</span>
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}

export default App;
