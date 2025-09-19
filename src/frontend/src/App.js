import React, { useState, useEffect } from 'react';
import { todoAPI } from './api';

function App() {
  const [todos, setTodos] = useState([]);
  const [newTodo, setNewTodo] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [editingId, setEditingId] = useState(null);
  const [editText, setEditText] = useState('');

  // Load todos on component mount
  useEffect(() => {
    loadTodos();
  }, []);

  const loadTodos = async () => {
    try {
      setLoading(true);
      setError('');
      const response = await todoAPI.getTodos();
      setTodos(response.data || []);
    } catch (err) {
      setError('Failed to load todos. Make sure your API is running.');
      console.error('Error loading todos:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleAddTodo = async (e) => {
    e.preventDefault();
    if (!newTodo.trim()) return;

    try {
      setError('');
      const response = await todoAPI.createTodo(newTodo.trim());
      setTodos([...todos, response.data]);
      setNewTodo('');
    } catch (err) {
      setError('Failed to create todo');
      console.error('Error creating todo:', err);
    }
  };

  const handleToggleTodo = async (todo) => {
    try {
      setError('');
      const updatedTodo = { ...todo, checked: !todo.checked };
      await todoAPI.updateTodo(todo.id, updatedTodo);
      setTodos(todos.map(t => t.id === todo.id ? updatedTodo : t));
    } catch (err) {
      setError('Failed to update todo');
      console.error('Error updating todo:', err);
    }
  };

  const handleDeleteTodo = async (id) => {
    try {
      setError('');
      await todoAPI.deleteTodo(id);
      setTodos(todos.filter(t => t.id !== id));
    } catch (err) {
      setError('Failed to delete todo');
      console.error('Error deleting todo:', err);
    }
  };

  const handleEditStart = (todo) => {
    setEditingId(todo.id);
    setEditText(todo.text);
  };

  const handleEditSave = async (id) => {
    if (!editText.trim()) return;

    try {
      setError('');
      const todo = todos.find(t => t.id === id);
      const updatedTodo = { ...todo, text: editText.trim() };
      await todoAPI.updateTodo(id, updatedTodo);
      setTodos(todos.map(t => t.id === id ? updatedTodo : t));
      setEditingId(null);
      setEditText('');
    } catch (err) {
      setError('Failed to update todo');
      console.error('Error updating todo:', err);
    }
  };

  const handleEditCancel = () => {
    setEditingId(null);
    setEditText('');
  };

  if (loading) {
    return (
      <div className="container">
        <div className="loading">Loading todos...</div>
      </div>
    );
  }

  return (
    <div className="container">
      <div className="header">
        <h1>Todo App</h1>
        <p>Manage your tasks with this simple todo application</p>
      </div>

      {error && (
        <div className="error">
          {error}
        </div>
      )}

      <form onSubmit={handleAddTodo} className="add-todo">
        <input
          type="text"
          value={newTodo}
          onChange={(e) => setNewTodo(e.target.value)}
          placeholder="Enter a new todo..."
          maxLength={200}
        />
        <button type="submit" disabled={!newTodo.trim()}>
          Add Todo
        </button>
      </form>

      <ul className="todo-list">
        {todos.length === 0 ? (
          <li className="todo-item">
            <span className="todo-text">No todos yet. Add one above!</span>
          </li>
        ) : (
          todos.map((todo) => (
            <li key={todo.id} className={`todo-item ${todo.checked ? 'completed' : ''}`}>
              <input
                type="checkbox"
                checked={todo.checked}
                onChange={() => handleToggleTodo(todo)}
              />
              
              {editingId === todo.id ? (
                <div className="edit-form">
                  <input
                    type="text"
                    value={editText}
                    onChange={(e) => setEditText(e.target.value)}
                    onKeyPress={(e) => e.key === 'Enter' && handleEditSave(todo.id)}
                    autoFocus
                  />
                  <button 
                    type="button" 
                    className="btn-save"
                    onClick={() => handleEditSave(todo.id)}
                  >
                    Save
                  </button>
                  <button 
                    type="button" 
                    className="btn-cancel"
                    onClick={handleEditCancel}
                  >
                    Cancel
                  </button>
                </div>
              ) : (
                <>
                  <span className={`todo-text ${todo.checked ? 'completed' : ''}`}>
                    {todo.text}
                  </span>
                  <div className="todo-actions">
                    <button 
                      className="btn-edit"
                      onClick={() => handleEditStart(todo)}
                    >
                      Edit
                    </button>
                    <button 
                      className="btn-delete"
                      onClick={() => handleDeleteTodo(todo.id)}
                    >
                      Delete
                    </button>
                  </div>
                </>
              )}
            </li>
          ))
        )}
      </ul>
    </div>
  );
}

export default App;