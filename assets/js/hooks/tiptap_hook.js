import { Editor } from "@tiptap/core";
import StarterKit from "@tiptap/starter-kit";
import Underline from "@tiptap/extension-underline";
import { registerCommands, updateAllButtonStates } from "./tiptap_commands"; // Fixed typo in import path

/**
 * Phoenix LiveView hook for TipTap editor integration
 */
const TiptapHook = {
  mounted() {
    this.setupEditor();
  },

  updated() {
    // Clean up event listeners before re-initializing
    if (this.cleanupCommandListeners) {
      this.cleanupCommandListeners();
    }

    // Clean up existing editor before re-initializing
    if (this.editor) {
      this.editor.destroy();
    }

    // Re-initialize the editor with fresh state
    this.setupEditor();
  },

  destroyed() {
    // Clean up command listeners
    if (this.cleanupCommandListeners) {
      this.cleanupCommandListeners();
    }

    // Clean up resources when component is removed
    if (this.editor) {
      this.editor.destroy();
      this.editor = null;
    }
  },

  /**
   * Common setup logic for editor initialization
   */
  setupEditor() {
    // Get parent and hidden input elements
    this.parent = this.el.parentElement;
    this.hiddenInput = this.parent.querySelector("input");

    // Get command buttons
    this.commandButtonList = this.parent.querySelectorAll(
      "[data-tiptap-command]"
    );

    // Initialize editor
    this.editor = new Editor({
      element: this.el,
      extensions: [StarterKit, Underline],
      content: this.hiddenInput.value,
      onUpdate: ({ editor }) => {
        requestAnimationFrame(() => {
          this.hiddenInput.value = editor.getHTML();
          const inputEvent = new Event("input", {
            bubbles: true,
            cancelable: true,
          });
          this.hiddenInput.dispatchEvent(inputEvent);
        });
      },
      onSelectionUpdate: () => {
        updateAllButtonStates(this.editor, this.commandButtonList);
      },
      onBlur: ({ event }) => {
        requestAnimationFrame(() => {
          this.hiddenInput.dispatchEvent(event);
        });
      },
    });

    // Register commands and update button states
    this.cleanupCommandListeners = registerCommands(
      this.editor,
      this.commandButtonList
    );
    updateAllButtonStates(this.editor, this.commandButtonList);
  },
};

export default TiptapHook;
