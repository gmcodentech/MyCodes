//This is not a code but an excerb from 'https://www.openmymind.net/Zig-Quirks/'
//for understanding the naming conventions , this is added for my reference

// In general:

    // Functions are camelCase
    // Types are PascalCase
    // Variables are lowercase_with_underscores 

// The main exception to this rule are functions that returns 
// types (most commonly used with generics). These are PascalCade.

// Normally, file names are lowercase_with_underscore. 
// However, files that expose a type directly (like our last tea example), 
// follow the type naming rule. Thus, the file should have been called "Tea.zig".

// It's easy to follow but is more colorful than what I'm used to.