export function create_validation_function(min, max) {
  return (x) => {
    return Math.max(min, Math.min(max, x));
  };
}
