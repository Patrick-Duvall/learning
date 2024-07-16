https://css-tricks.com/an-introduction-to-web-components/

# What are web components

1.Custom Elements:fully valid html elements with custom templates, behaviors, and tag names
2.Shadow Dom: isolates JS and CSS, like an iframe
3.HTML templates: User-defined templates in HTML that aren’t rendered until called upon.

Custom elements contain their own semantics, behaviors, markup and can be shared across frameworks and browsers.

## Custom elements
Html elements like `div` that *we* can define via a browser API that *always* have a dash i.e. `<scale-slider>`

super basic web component
```javascript
class MyComponent extends HTMLElement {
  connectedCallback() {
    this.innerHTML = `<h1>Hello world</h1>`;
  }
}
    
customElements.define('my-component', MyComponent);
```

All custom elements extend `HTMLElement` to be registered with a browser

because these are written in vanillaJS, they can be used out of the box with most popular frameworks.

## Shadow Dom

an encapsulated version of the dom, allowing authors to isolate DOM fragments

content inside the documents scope is the "light DOM" and content inside a shadow root the shadow DOM.

When using the light DOM, an element can be selected by using document.querySelector('selector') or by targeting any element’s children by using element.querySelector('selector');

in the same way, a shadow root’s children can be targeted by calling shadowRoot.querySelector where shadowRoot is a reference to the document fragment — the difference being that the shadow root’s children will not be select-able from the light DOM

If we have a shadow root with a <button> inside of it, calling shadowRoot.querySelector('button') returns our button, but no invocation of the document’s query selector will return that element because it belongs to a different DocumentOrShadowRoot instance.

```html
<div id="example">This will use the CSS background</div>
<button id="button">Not tomato</button>
```
```javascript
const shadowRoot = document.getElementById('example').attachShadow({ mode: 'open' });
shadowRoot.innerHTML = `<style>
button {
  background: tomato;
  color: white;
}
</style>
<button id="button"><slot></slot> tomato</button>`;
```

This code renders 2 buttons, but only the one with the attached shadow is `color: tomato`

## HTML templates
The HTML `<template>` element allows us to stamp out re-usable templates of code inside a normal HTML flow that won’t be immediately rendered, but can be used at a later time.

```html
<template id="book-template">
  <li><span class="title"></span> &mdash; <span class="author"></span></li>
</template>

<ul id="books"></ul>
```

This example does not render any code until a JS script has consumed the template, instantiated the code, and told the browser what to do with it.

```javascript
const fragment = document.getElementById('book-template');
const books = [
  { title: 'The Great Gatsby', author: 'F. Scott Fitzgerald' },
  { title: 'A Farewell to Arms', author: 'Ernest Hemingway' },
  { title: 'Catch 22', author: 'Joseph Heller' }
];

books.forEach(book => {
  // Create an instance of the template content
  const instance = document.importNode(fragment.content, true);
  // Add relevant content to the template
  instance.querySelector('.title').innerHTML = book.title;
  instance.querySelector('.author').innerHTML = book.author;
  // Append the instance ot the DOM
  document.getElementById('books').appendChild(instance);
});
```

The consumer of the template API could write a template of any shape

```html
<template id="book-template">
  <li><span class="author"></span>'s classic novel <span class="title"></span></li>
</template>

<ul id="books"></ul>
```
