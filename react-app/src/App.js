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
      const response = await fetch('http://demoalbforserver-2106681401.us-east-1.elb.amazonaws.com:8080/health/demo', {
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
      const response = await fetch('http://demoalbforserver-2106681401.us-east-1.elb.amazonaws.com:8080/test', {
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
    <div>
      <form onSubmit={handleSubmit}>
        <span>Enter username:</span>
        <input type="text" name="username" value={form.username} onChange={handleForm} required />
        <span>Password:</span>
        <input type="password" name="password" value={form.password} onChange={handleForm} required />
        <input type="submit" value="Submit" />
      </form>

      {/* List of users displayed below the form */}
      <div>
        <ul>
          {users.map((user) => (
            <li key={user._id}>
              {user.username}, {user.password}
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}

export default App;
