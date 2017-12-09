exports.abstract = (classNamesAndMethods) ->
  for className, methodNames of classNamesAndMethods
    klass =
      eval """
        class #{className} {
          constructor (...args) {
            if (@constructor is #{className}) {
              throw new Error("Cannot instantiate abstract class '#{className}'");
            }

            #{className}.init(this, args);
          }
        };
      """

    for name in methodNames
      klass::[name] = -> throw new Error "Virtual method '#{name}' not overriden in #{@constructor.name}"
