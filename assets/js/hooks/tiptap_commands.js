/**
 * TipTap editor command utilities
 * Manages button interactions and command execution for the TipTap editor
 */

/**
 * Maps command names to their corresponding TipTap editor chain functions
 * @type {Object.<string, function(import('@tiptap/core').Editor): void>}
 */
const COMMAND_MAP = {
  // Text formatting
  bold: (editor) => editor.chain().focus().toggleBold().run(),
  italic: (editor) => editor.chain().focus().toggleItalic().run(),
  underline: (editor) => editor.chain().focus().toggleUnderline().run(),
  strike: (editor) => editor.chain().focus().toggleStrike().run(),
  code: (editor) => editor.chain().focus().toggleCode().run(),

  // Headings
  heading1: (editor) =>
    editor.chain().focus().toggleHeading({ level: 1 }).run(),
  heading2: (editor) =>
    editor.chain().focus().toggleHeading({ level: 2 }).run(),

  // Lists
  bulletList: (editor) => editor.chain().focus().toggleBulletList().run(),
  orderedList: (editor) => editor.chain().focus().toggleOrderedList().run(),

  // Block elements
  blockquote: (editor) => editor.chain().focus().toggleBlockquote().run(),
  codeBlock: (editor) => editor.chain().focus().toggleCodeBlock().run(),
  horizontalRule: (editor) => editor.chain().focus().setHorizontalRule().run(),
  hardBreak: (editor) => editor.chain().focus().setHardBreak().run(),

  // History
  undo: (editor) => editor.chain().focus().undo().run(),
  redo: (editor) => editor.chain().focus().redo().run(),
};

/**
 * Registers click event handlers for command buttons
 * @param {import('@tiptap/core').Editor} editor - The TipTap editor instance
 * @param {NodeListOf<Element>|HTMLElement[]} commandButtonList - The button elements to register commands for
 * @returns {Function} Cleanup function to remove event listeners
 */
export function registerCommands(editor, commandButtonList) {
  if (!editor || !commandButtonList?.length) {
    console.warn("TipTap: Missing editor or command buttons");
    return () => {};
  }

  // Store click handlers to enable proper cleanup
  const handlers = new Map();

  Array.from(commandButtonList).forEach((button) => {
    const command = button.dataset.tiptapCommand;

    if (!command || !COMMAND_MAP[command]) {
      console.warn(`TipTap: Unknown command "${command}" for button`, button);
      return;
    }

    const clickHandler = (e) => {
      e.preventDefault();
      executeCommand(editor, command);

      // Update all button states after any command execution
      // This ensures UI stays in sync with editor state
      updateAllButtonStates(editor, commandButtonList);
    };

    // Store handler reference for cleanup
    handlers.set(button, clickHandler);

    // Add event listener
    button.addEventListener("click", clickHandler);
  });

  // Return cleanup function
  return () => {
    handlers.forEach((handler, button) => {
      button.removeEventListener("click", handler);
    });
    handlers.clear();
  };
}

/**
 * Updates the active state of all command buttons based on current editor state
 * @param {import('@tiptap/core').Editor} editor - The TipTap editor instance
 * @param {NodeListOf<Element>|HTMLElement[]} commandButtonList - The button elements to update
 */
export function updateAllButtonStates(editor, commandButtonList) {
  if (!editor || !commandButtonList?.length) return;

  Array.from(commandButtonList).forEach((button) => {
    const command = button.dataset.tiptapCommand;

    if (!command) return;

    // For commands that don't have an "active" state (like undo/redo)
    // we don't modify the active class
    if (["undo", "redo", "horizontalRule", "hardBreak"].includes(command)) {
      // Optionally disable undo/redo buttons based on history state
      if (command === "undo") {
        button.disabled = !editor.can().undo();
      } else if (command === "redo") {
        button.disabled = !editor.can().redo();
      }
      return;
    }

    // Handle special case for headings which need level parameter
    if (command.startsWith("heading")) {
      const level = parseInt(command.replace("heading", ""), 10);
      button.classList.toggle(
        "is-active",
        editor.isActive("heading", { level })
      );
      return;
    }

    // Standard command toggle
    button.classList.toggle("is-active", editor.isActive(command));
  });
}

/**
 * Executes a TipTap editor command
 * @param {import('@tiptap/core').Editor} editor - The TipTap editor instance
 * @param {String} command - The command name to execute
 * @returns {Boolean} Whether the command was executed successfully
 */
export function executeCommand(editor, command) {
  if (!editor) {
    console.error("TipTap: Editor instance is required to execute commands");
    return false;
  }

  if (!command) {
    console.error("TipTap: Command name is required");
    return false;
  }

  const commandFn = COMMAND_MAP[command];

  if (!commandFn) {
    console.warn(`TipTap: Unknown command "${command}"`);
    return false;
  }

  try {
    commandFn(editor);
    return true;
  } catch (error) {
    console.error(`TipTap: Error executing command "${command}"`, error);
    return false;
  }
}
