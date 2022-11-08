const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = (env, options) => ({
  devtool: 'source-maps',
  optimization: {
    minimizer: [
      new UglifyJsPlugin({ cache: true, parallel: true, sourceMap: false }),
      new OptimizeCSSAssetsPlugin({})
    ]
  },
  resolve: {
    modules: [path.resolve(__dirname, './css/primary'), path.resolve(__dirname, './src/app'), 'node_modules'],
    extensions: ['.js', '.html', '.ts', '.tsx','.jsx', '.json'],
    alias: {}
  },
  entry: {
    './src/app/app.ts': glob.sync('./vendor/**/*.js').concat(['./src/app/app.ts']),
  },
  output: {
    filename: 'app.js',
    path: path.resolve(__dirname, '../assets/js')
  },
  module: {
    rules: [
      {
        test: /\.ts$/,
        enforce: 'pre',
        use: [
          {
            loader: 'tslint-loader',
            options: {
              fix: true
            }
          }
        ]
      },
      {
          test: /\.tsx?$/,
          exclude: /node_modules/,
          use: {
            loader: 'ts-loader'
          },
      },
      {
        test: /\.jsx?$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader'
        }
      },
      {
        test: /\.css$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader']
      },
      {
        test: /\.html$/,
        use: {loader: 'html-loader'}
      }
    ]
  },
  plugins: [
    new MiniCssExtractPlugin({ filename: '../css/app.css' })
  ]
});
